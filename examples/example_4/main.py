import sys
from pathlib import Path
import pandas as pd

# Adjust the path to include the src directory
current_dir = Path(__name__).resolve().parent
current_dir = str(current_dir) + '\\src'
sys.path.append(current_dir)

# Import the necessary module
from baseSAA import baseSAA

# Load data
vacancies = pd.read_csv('data/example_4/vacancies_junji_2025.csv')
applications = pd.read_csv('data/example_4/applications_junji_2025.csv')

# Prep data for different mechanisms
base_da = applications[['applicant_id', 'grade_id', 'program_id', 'ranking', 'quota_id', 'priority_profile','lottery_number']]
vacancies = vacancies[['program_id', 'regular_vacancies']]

# Execute the assignment algorithms
results_1 = baseSAA(apps=base_da, vacs=vacancies, get_cutoffs=True,transfer_capacity=False,iters=1)
results_2 = baseSAA(apps=base_da, vacs=vacancies, get_cutoffs=True,transfer_capacity=False,iters=50,
                    get_assignment=False,get_probs=True)

# Export assignment:
results_1['assignment'].to_csv('data/example_4/results_official_py.csv',index=False)

# Export cutoffs:
results_1['cutoffs'].to_csv('data/example_4/cutoffs_official_py.csv',index=False)
results_2['cutoffs'].to_csv('data/example_4/cutoffs_simulations_py.csv', index=False)

# Export ratex:
results_2['ratex'].to_csv('data/example_4/ratex_simulations_py.csv', index=False)