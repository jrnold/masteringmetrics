
# Mississippi Bank Failures in the Great Depression

A difference-in-difference analysis of Mississippi bank failures during the Great Depression [@RichardsonTroost2009].
This replicates Figures 5.1--5.3 in *Mastering 'Metrics*.


```r
library("tidyverse")
library("lubridate")
```

Load the `banks` data.

```r
data("banks", package = "masteringmetrics")
```

Only use yearly data in the difference-in-difference estimates.
Use the number of banks on July 1st of each year.

```r
banks <- banks %>%
  filter(month(date) == 7L, mday(date) == 1L) %>%
  mutate(year = year(date)) %>%
  select(year, matches("bi[ob][68]"))
```
Generate the counterfactual using the difference between the number of banks in district 8 and district 6.

```r
banks <- banks %>%
  arrange(year) %>%
  mutate(diff86 = bib8[year == 1930] - bib6[year == 1930],
         counterfactual = if_else(year >= 1930, bib8 - diff86, NA_integer_)) %>%
  select(-diff86)
         
```

Plot the lines of the Distinct 8 banks in business, District 6 banks in business, and the District 6 counterfactual. 
This is equivalent to Figure 5.3 of @AngristPischke2014.

```r
select(banks, year, bib8, bib6, counterfactual) %>%
  gather(variable, value, -year, na.rm = TRUE) %>%
  mutate(variable = recode(variable, bib8 = "8th district",
                           bib6 = "6th district",
                           counterfactual = "Counterfactual")) %>%
  ggplot(aes(x = year, y = value, colour = variable)) +
  geom_point() +
  geom_line() +
  ylab("Number of Banks in Business") +
  xlab("")
```



\begin{center}\includegraphics[width=0.7\linewidth]{banks_files/figure-latex/fig5.3-1} \end{center}

Plot the difference-in-difference estimate for all years after 1930.

```r
ggplot(filter(banks, year > 1930), aes(x = year, y = bib6 - counterfactual)) +
  geom_point() +
  geom_line() +
  ylab("DID (Number of Banks)") +
  xlab("")
```

\begin{figure}

{\centering \includegraphics[width=0.7\linewidth]{banks_files/figure-latex/plot-bank-year-diff-1} 

}

\caption{Difference between Eighth District and Sixth District Counterfactuals}(\#fig:plot-bank-year-diff)
\end{figure}

## References

- <http://masteringmetrics.com/wp-content/uploads/2015/02/master_banks.do>
- <http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_BankFailures.txt>


