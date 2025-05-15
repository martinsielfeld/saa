import pandas as pd

def prepStats(apps, vacs, assigned, prio, iteration):
    # Compute ass_priority_profile by truncating score
    d3 = assigned[['applicant_id', 'score']].copy()
    d3['ass_priority_profile'] = d3['score'].astype(int)
    d3.drop(columns='score', inplace=True)

    # Merge with original applications
    d3 = apps.merge(d3, on='applicant_id', how='left')
    
    # Avoid SettingWithCopyWarning by assigning result explicitly
    d3['ass_priority_profile'] = d3['ass_priority_profile'].fillna(0)

    # Filter: only where ass_priority_profile >= priority_profile
    d3 = d3[d3['ass_priority_profile'] >= d3['priority_profile']]

    # Count considered applications
    d3 = d3.groupby(['program_id', 'quota_id', 'priority_profile']).size().reset_index(name='n_considered')

    # Total applicants per program-quota pair
    tot_apps = apps.groupby(['program_id', 'quota_id']).size().reset_index(name='total_applicants')

    # Assigned counts per priority
    assigned_grouped = assigned.groupby(['program_id', 'quota_id', 'priority_profile']).size().reset_index(name='assigned')

    # Merge all into pp
    pp = prio.merge(assigned_grouped, on=['program_id', 'quota_id', 'priority_profile'], how='left')
    pp = pp.merge(tot_apps, on=['program_id', 'quota_id'], how='left')
    pp = pp.merge(d3, on=['program_id', 'quota_id', 'priority_profile'], how='left')
    pp.fillna(0, inplace=True)

    # Cumulative assignments
    pp['cum_ass'] = pp.groupby(['program_id', 'quota_id'])['assigned'].cumsum()

    # Merge in seat info
    seat_info = vacs.groupby(['program_id', 'quota_id']).agg(seats=('seat_order', 'max')).reset_index()
    pp = pp.merge(seat_info, on=['program_id', 'quota_id'], how='left')
    pp.fillna(0, inplace=True)

    # Add iteration index
    pp['iter'] = iteration

    # Sort (fixing invalid use of -Series inside `by`)
    pp['priority_profile'] = pp['priority_profile'].astype(int)
    pp.sort_values(
        by=['iter', 'program_id', 'quota_id', 'priority_profile'],
        ascending=[True, True, True, False],
        inplace=True
    )

    # Compute assigned in this iteration
    pp['assigned'] = pp.groupby(['iter', 'program_id', 'quota_id'])['cum_ass'].shift().fillna(0)
    pp['assigned'] = pp['cum_ass'] - pp['assigned']
    pp['cum_ass'] -= pp['assigned']

    # Update seat availability
    pp['total_seats'] = pp['seats']
    pp['seats'] -= pp['cum_ass']

    return pp
