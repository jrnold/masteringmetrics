
---
output: html_document
editor_options: 
  chunk_output_type: console
---
# Twins and Returns to Schooling

Estimates of the returns to schooling for Twinsburg twins [@AshenfelterKrueger1994;@AshenfelterRouse1998].
This replicates the analysis in Table 6.2 of *Mastering 'Metrics*.


```r
library("tidyverse")
library("sandwich")
library("lmtest")
library("AER")
```

Load `twins` data.

```r
data("pubtwins", package = "masteringmetrics")
```

Run a regression of log wage on controls (Column 1 of Table 6.2).

```r
mod1 <- lm(lwage ~ educ + poly(age, 2) + female + white, data = pubtwins)
coeftest(mod1, vcov = sandwich)
#> 
#> t test of coefficients:
#> 
#>               Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)     1.1791     0.1631    7.23  1.3e-12 ***
#> educ            0.1100     0.0104   10.54  < 2e-16 ***
#> poly(age, 2)1   4.9643     0.5697    8.71  < 2e-16 ***
#> poly(age, 2)2  -4.2957     0.5919   -7.26  1.1e-12 ***
#> female         -0.3180     0.0397   -8.00  5.4e-15 ***
#> white          -0.1001     0.0679   -1.47     0.14    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
*Note:* The `age` coefficients are different (but equivalent) to those reported in the Table due to the the use of `poly(age, .)`, which calculates orthogonal polynomials.

Run regression of the difference in log wage between twins on the difference in education (Column 2 of Table 6.2).

```r
mod2 <- lm(dlwage ~ deduc, data = filter(pubtwins, first == 1))
coeftest(mod2, vcov = sandwich)
#> 
#> t test of coefficients:
#> 
#>             Estimate Std. Error t value Pr(>|t|)   
#> (Intercept)   0.0296     0.0275    1.07   0.2835   
#> deduc         0.0610     0.0198    3.09   0.0022 **
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Run a regression of log wage on controls, instrumenting education with twin's education (Column 3 of Table 6.2).

```r
mod3 <- ivreg(lwage ~ educ + poly(age, 2) + female + white |
                . - educ + educt, data = pubtwins)
summary(mod3, vcov = sandwich, diagnostics = TRUE)
#> 
#> Call:
#> ivreg(formula = lwage ~ educ + poly(age, 2) + female + white | 
#>     . - educ + educt, data = pubtwins)
#> 
#> Residuals:
#>      Min       1Q   Median       3Q      Max 
#> -1.69585 -0.29218  0.00494  0.26262  2.47060 
#> 
#> Coefficients:
#>               Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)     1.0636     0.2113    5.03  6.2e-07 ***
#> educ            0.1179     0.0137    8.62  < 2e-16 ***
#> poly(age, 2)1   5.0367     0.5805    8.68  < 2e-16 ***
#> poly(age, 2)2  -4.2897     0.5928   -7.24  1.3e-12 ***
#> female         -0.3149     0.0403   -7.81  2.2e-14 ***
#> white          -0.0974     0.0682   -1.43     0.15    
#> 
#> Diagnostic tests:
#>                  df1 df2 statistic p-value    
#> Weak instruments   1 674    796.30  <2e-16 ***
#> Wu-Hausman         1 673      0.92    0.34    
#> Sargan             0  NA        NA      NA    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 0.507 on 674 degrees of freedom
#> Multiple R-Squared: 0.338,	Adjusted R-squared: 0.333 
#> Wald test: 56.8 on 5 and 674 DF,  p-value: <2e-16
```
*Note:* The coefficient for years of education is slightly different than that reported in the book.

Run a regression of the difference in wage, instrumenting the difference in years of education with twin's education (Column 4 of Table 6.2).

```r
mod4 <- ivreg(dlwage ~ deduc | deduct,
              data = filter(pubtwins, first == 1))
summary(mod4, vcov = sandwich, diagnostics = TRUE)
#> 
#> Call:
#> ivreg(formula = dlwage ~ deduc | deduct, data = filter(pubtwins, 
#>     first == 1))
#> 
#> Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -2.0423 -0.3111 -0.0274  0.2471  2.0824 
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)   
#> (Intercept)   0.0274     0.0277    0.99   0.3237   
#> deduc         0.1070     0.0339    3.15   0.0018 **
#> 
#> Diagnostic tests:
#>                  df1 df2 statistic p-value    
#> Weak instruments   1 338     85.15  <2e-16 ***
#> Wu-Hausman         1 337      4.12   0.043 *  
#> Sargan             0  NA        NA      NA    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Residual standard error: 0.512 on 338 degrees of freedom
#> Multiple R-Squared: 0.0132,	Adjusted R-squared: 0.0103 
#> Wald test: 9.94 on 1 and 338 DF,  p-value: 0.00176
```
*Note:* The coefficient for years of education is slightly different than that reported in the book.

## References {-}

-   <http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_Twinsburg.txt>
-   <http://masteringmetrics.com/wp-content/uploads/2015/02/twins.do>


