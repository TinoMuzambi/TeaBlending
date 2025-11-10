# Tea Blending Optimization: Complete R Markdown Implementation

## Overview

Implement a complete R Markdown document that solves the tea blending optimization problem using four different approaches as described in the technical report.

## Implementation Structure

### 1. Setup and Data Preparation

- **File**: `tea_blending_optimization.Rmd`
- Load required libraries: `dplyr`, `ompr`, `lpSolveAPI`, `ggplot2`, `GA`
- Create sample data structures based on Fomeni's Tables 2 & 3:
- Raw materials data frame with: material ID, unit cost (Pi), availability (ai), quality characteristics (gik)
- Blends data frame with: blend ID, demand (Dj), target quality scores (sjk)
- Define indices: i (raw materials), j (blends), k (quality characteristics)
- Set tolerance parameters (εjk) for relaxed constraints

### 2. Approach 1: Linear Programming (Cost Minimization)

- **Section**: "3.0 Approach 1: Cost Minimization using Linear Programming"
- Implement using `ompr` package:
- Define decision variables xij (continuous, non-negative)
- Objective function: minimize ΣΣ Pi \* xij
- Constraints:
- Raw material availability: Σj xij ≤ ai ∀i
- Blend demand: Σi xij ≥ Dj ∀j
- Characteristic score relaxation (with εjk tolerance)
- Solve using `ompr` solver
- Extract and display:
- Optimal total cost
- Optimal xij matrix (recipe for each blend)
- Visualization of solution

### 3. Approach 2: Simulated Annealing (Cost Minimization)

- **Section**: "4.0 Approach 2: Cost Minimization using Simulated Annealing"
- Implement custom SA algorithm:
- State representation: matrix of xij values
- Initial solution generation (feasible starting point)
- Neighborhood function: small perturbations to xij values while maintaining feasibility
- Cooling schedule: exponential or linear decay
- Acceptance criterion: Metropolis criterion
- Constraint handling: repair operators for infeasible neighbors
- Track convergence and solution quality
- Compare results with LP solution
- Visualization: convergence plot, solution comparison

### 4. Approach 3: Chebyshev Goal Programming (Multi-objective)

- **Section**: "5.0 Approach 3: Multi-objective Optimization using Chebyshev Goal Programming"
- Implement multi-objective model:
- Define goals: cost target and quality targets
- Decision variables: xij and deviation variables (yjk)
- Objective: minimize worst-case deviation (Chebyshev metric)
- Constraints: same as LP plus goal constraints
- Solve using LP solver (can be reformulated as LP)
- Extract balanced solution
- Visualization: trade-off analysis, goal achievement

### 5. Approach 4: Genetic Algorithms (Optional)

- **Section**: "6.0 Approach 4: Genetic Algorithms (Optional)"
- Implement using `GA` package:
- Chromosome encoding: flatten xij matrix to vector
- Fitness function: weighted sum of cost and quality deviations
- Genetic operators:
- Selection: tournament selection
- Crossover: blend or single-point crossover
- Mutation: small random changes to xij values
- Constraint handling: penalty-based or repair operators
- Population size, generations, mutation/crossover rates
- Track evolution and best solution
- Visualization: fitness evolution plot

### 6. Comparative Analysis and Reporting

- **Section**: "7.0 Summary of Results and Comparative Analysis"
- Create comparison table/metrics:
- Total cost for each approach
- Quality deviation measures
- Computation time
- Solution feasibility
- Visualizations:
- Cost comparison bar chart
- Quality deviation comparison
- Solution space exploration (if applicable)
- Summary conclusions

### 7. Document Structure

- YAML header with title, author, output format
- Markdown sections matching report structure
- Code chunks with appropriate chunk options (echo, eval, results)
- Inline results and formatted tables
- Professional formatting and documentation

## Technical Details

### Data Structure (Sample)

- **Raw Materials**: ~5-8 materials with costs, availability, 3-4 quality characteristics
- **Blends**: ~3-5 final blends with demand and target quality scores
- **Quality Characteristics**: e.g., brightness, colour, thickness (3-4 characteristics)

### Key Parameters

- εjk (tolerance): 0.1 or configurable
- SA parameters: initial temperature, cooling rate, iterations
- GA parameters: population size (50-100), generations (100-200), mutation rate (0.1), crossover rate (0.8)
- Goal programming weights: configurable based on priorities

### Libraries and Dependencies

- `dplyr`: data manipulation
- `ompr` + `ompr.roi` + `ROI.plugin.glpk`: LP modeling
- `lpSolveAPI`: alternative LP solver
- `ggplot2`: visualizations
- `GA`: genetic algorithms
- `knitr`: R Markdown processing

## Deliverables

- Single R Markdown file: `tea_blending_optimization.Rmd`
- Self-contained with all data generation
- Fully executable and reproducible
- Professional report output (HTML or PDF)
