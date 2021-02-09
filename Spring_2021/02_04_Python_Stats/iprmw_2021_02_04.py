# # Load Modules (with common abbreviations)
import numpy as np
import pandas as pd
from statsmodels.formula.api import ols
from statsmodels.formula.api import logit
from statsmodels.graphics.regressionplots import plot_fit
from statsmodels.iolib.summary2 import summary_col
import seaborn as sns
from stargazer.stargazer import Stargazer

# # Load Data as Pandas Dataframe (and look at attributes)
# (note: not all of the output is rendered, only the last command & plots)
auto = pd.read_stata('auto.dta', preserve_dtypes=False)
type(auto)
auto.shape
auto.describe()
auto.head()
auto_complete = auto.dropna()
auto_complete.shape

# # Linear Regression: mpg ~ weight + price
# ## descriptive statistics

auto['mpg'].describe()
auto[['mpg', 'weight']].describe()
auto[['mpg', 'weight']].mean()
auto[['mpg', 'weight']].std()
sns.pairplot(auto, vars=['mpg', 'weight', 'price'], kind='reg')
model1 = ols('mpg ~ weight + price', data=auto)
fit1 = model1.fit()
fit1.summary()
plot_fit(fit1, 'weight')
fit1.predict()
fit1.resid

# ## Interaction Terms (will include main effects)
ols('mpg ~ weight * price', data=auto).fit().summary()

# ## model with categorical variable & robust standard errors (same as Stata's reg, robust)
# ### [documentation for standard errors](https://www.statsmodels.org/dev/generated/statsmodels.regression.linear_model.RegressionResults.html) (search for HC0_se, HC1_se, etc.)
auto.groupby('foreign').size()
auto.groupby('foreign').mpg.mean()
sns.pairplot(auto, vars=['mpg', 'weight', 'price'], kind='reg', hue='foreign')
fit2 = ols('mpg ~ weight + price + foreign', data=auto).fit(cov_type='HC1')
fit2.summary()
fit2.params
fit2.bse
fit2.tvalues
fit2.pvalues
fit2.conf_int()
fit2.rsquared
fit2.rsquared_adj

# ## factor (from continuous variable)
auto.columns
auto['displacement'].describe()
pd.qcut(auto['displacement'], 3, labels=['low', 'med', 'high'])
auto['disp2'] = pd.qcut(auto['displacement'], 3, labels=['low', 'med', 'high'])
fit3 = ols('mpg ~ weight + disp2', data=auto).fit()
fit3.summary()
fit3b = ols("mpg ~ weight + C(disp2, Treatment(reference='med'))", data=auto).fit()
fit3b.summary()

# ## compare models
summary_col([fit1, fit2, fit3], stars=True)

# ## write results to CSV file
with open('mod3_summary.csv', 'w') as f:
    f.write(fit3.summary().as_csv())

# ## table for regression models
tab_params = pd.concat([fit1.params, fit2.params, fit3.params], axis=1,
                       keys=['Model 1', 'Model 2', 'Model 3'])
tab_bse = pd.concat([fit1.bse, fit2.bse, fit3.bse], axis=1,
                       keys=['Model 1', 'Model 2', 'Model 3'])
tab_params['stat'] = 'Beta'
tab_bse['stat'] = 'Std Error'
tab_all = tab_params.append(tab_bse)
tab_all.sort_index()
tab_all.sort_index().to_csv('table_models.csv')
## other options: https://github.com/mwburke/stargazer/blob/master/examples.ipynb
##                writes out html and latex files (for OLS models)


# # Logit Models
auto.foreign.value_counts()

# ## convert outcome to 0/1
auto['foreign'].replace(('Foreign', 'Domestic'), (1, 0))
auto['foreign_1_0'] = auto['foreign'].replace(('Foreign', 'Domestic'), (1, 0))

# ## seaborn's plotting tool
sns.regplot(x="weight", y="foreign_1_0", data=auto, logistic=True, y_jitter=0.04)

# ## fit model and get predicted probabilities
fit4 = logit('foreign_1_0 ~ weight + price', data=auto).fit()
fit4.summary()
predProbs = fit4.predict()
predProbs
auto['foreign_hat'] = predProbs
sns.scatterplot(data=auto, x='weight', y='foreign_hat', hue='price')

# ## another example of recoding: continuous variable -> categorical
auto.columns
auto['trunk']
auto['trunk'].value_counts()
auto['trunk_new'] = np.nan
auto.loc[auto['trunk'] <= 11, 'trunk_new'] = 1
auto[['trunk', 'trunk_new']]
auto.loc[(auto['trunk'] > 11) & (auto['trunk'] < 17), 'trunk_new'] = 2
auto[['trunk', 'trunk_new']]
auto.loc[auto['trunk'] >= 17, 'trunk_new'] = 3

logit('foreign_1_0 ~ C(trunk_new)', data=auto).fit().summary()

# *what's the problem hear?*
pd.crosstab(auto['trunk_new'], auto['foreign_1_0'])

# *ah, there are no foreign cars with trunk_new == 3*

# ## marginal effects (does not work for interaction or polynomial terms)
marginal_foreign = fit4.get_margeff(at='overall')
marginal_foreign.summary()

# ## another example with marginal predicted probabilities
# [try to reproduce this example](https://stats.idre.ucla.edu/stata/dae/using-margins-for-predicted-probabilities/) (still not there, need standard errors!)
hsb = pd.read_stata('https://stats.idre.ucla.edu/stat/data/hsbdemo.dta',
                    preserve_dtypes=False)
hsb.info()
pd.get_dummies(hsb.honors)
hsb['enrolled'] = pd.get_dummies(hsb.honors, drop_first=True)
hsb[['honors', 'enrolled']]

fit6 = logit('enrolled ~ C(female) + read', data=hsb).fit()
## compare predictions to observed (correct predictions on diagonal)
fit6.pred_table()
fit6.summary()
hsb['mu_read'] = hsb.read.mean()
pred_hsb = hsb.copy()
pred_hsb['read'] = hsb.read.mean()
pred_enrolled = fit6.predict(exog=pred_hsb)
pred_hsb['y_hat'] = fit6.predict(exog=pred_hsb)
pred_hsb.groupby('female').y_hat.mean()
