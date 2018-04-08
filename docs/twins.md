
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
coeftest(mod1, vcov = vcovHC(mod1))
#> 
#> t test of coefficients:
#> 
#>               Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)     1.1791     0.1656    7.12  2.7e-12 ***
#> educ            0.1100     0.0106   10.41  < 2e-16 ***
#> poly(age, 2)1   4.9643     0.5810    8.54  < 2e-16 ***
#> poly(age, 2)2  -4.2957     0.6074   -7.07  3.8e-12 ***
#> female         -0.3180     0.0401   -7.92  9.6e-15 ***
#> white          -0.1001     0.0698   -1.43     0.15    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
*Note:* The `age` coefficients are different (but equivalent) to those reported in the Table due to the the use of `poly(age, .)`, which calculates orthogonal polynomials.

Run regression of the difference in log wage between twins on the difference in education (Column 2 of Table 6.2).

```r
mod2 <- lm(dlwage ~ deduc, data = filter(pubtwins, first == 1))
coeftest(mod2, vcov = vcovHC(mod2))
#> 
#> t test of coefficients:
#> 
#>             Estimate Std. Error t value Pr(>|t|)   
#> (Intercept)   0.0296     0.0277    1.07   0.2866   
#> deduc         0.0610     0.0201    3.03   0.0026 **
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Run a regression of log wage on controls, instrumenting education with twin's education (Column 3 of Table 6.2).

```r
mod3 <- ivreg(lwage ~ educ + poly(age, 2) + female + white | 
                . - educ + educt, data = pubtwins)
coeftest(mod3, vcov = vcovHC(mod3))
#> 
#> t test of coefficients:
#> 
#>               Estimate Std. Error t value Pr(>|t|)    
#> (Intercept)     1.0636     0.2143    4.96  8.8e-07 ***
#> educ            0.1179     0.0139    8.51  < 2e-16 ***
#> poly(age, 2)1   5.0367     0.5922    8.50  < 2e-16 ***
#> poly(age, 2)2  -4.2897     0.6086   -7.05  4.5e-12 ***
#> female         -0.3149     0.0407   -7.74  3.7e-14 ***
#> white          -0.0974     0.0701   -1.39     0.17    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
*Note:* The coefficient for years of education is slightly different than that reported in the book.

Run a regression of the difference in wage, instrumenting the difference in years of education with twin's education (Column 4 of Table 6.2).

```r
mod4 <- ivreg(dlwage ~ deduc | deduct,
              data = filter(pubtwins, first == 1))
coeftest(mod4, vcov = vcovHC(mod4))
#> 
#> t test of coefficients:
#> 
#>             Estimate Std. Error t value Pr(>|t|)   
#> (Intercept)   0.0274     0.0279    0.98   0.3272   
#> deduc         0.1070     0.0348    3.07   0.0023 **
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
*Note:* The coefficient for years of education is slightly different than that reported in the book.

## References {-}

-   <http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_Twinsburg.txt>
-   <http://masteringmetrics.com/wp-content/uploads/2015/02/twins.do>


