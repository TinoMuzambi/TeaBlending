# Tea Blending Optimisation

An operations-research case study comparing four approaches to a constrained tea-blending problem:

- linear programming;
- simulated annealing;
- Chebyshev goal programming; and
- a genetic algorithm.

The analysis uses the published problem data from Fomeni (2018), cited in [`references.bib`](references.bib). It compares feasibility, total cost, and quality deviation across exact and metaheuristic methods. No proprietary or personally supplied production data is included.

## Reproduce the report

The source of truth is [`tea_blending_optimization.Rmd`](tea_blending_optimization.Rmd). Use a current R installation with Pandoc and GLPK available, then install the document dependencies:

```r
install.packages(c(
  "dplyr", "Rglpk", "ompr", "ompr.roi", "ROI", "ROI.plugin.glpk",
  "lpSolveAPI", "ggplot2", "GA", "knitr", "flextable", "tidyr",
  "rmarkdown"
))
```

Render HTML with:

```bash
Rscript -e 'rmarkdown::render("tea_blending_optimization.Rmd", output_format = "html_document")'
```

PDF output additionally requires a working XeLaTeX installation:

```bash
Rscript -e 'rmarkdown::render("tea_blending_optimization.Rmd", output_format = "pdf_document")'
```

Generated reports are intentionally not committed. This keeps the repository reviewable and prevents rendered documents from drifting away from their source.

## Reproducibility notes

- The stochastic methods use a fixed seed so repeated renders begin from the same random state.
- Package versions and solver implementations can still affect numerical results. The rendered appendix records `sessionInfo()` for traceability.
- Model inputs are transcribed from the cited paper. Check the source publication before using the results for real production decisions.

## Scope

This is an analytical case study, not a production planning system. A production implementation would still need input validation, data lineage, solver monitoring, sensitivity analysis, and domain review of the quality constraints.

## Licence

The analysis code is released under the MIT licence. The cited paper and its underlying data remain subject to their respective rights and terms.
