import pandas as pd

def getCutoffs(apps=None, vacs=None, assigned=None, cutoffs=None, iterat=None, hard_quota=False):

    assigned['assigned'] = 1

    if not hard_quota:
        apps['score'] = apps['priority_profile'] + apps['lottery_number']
        apps = apps.merge(assigned[['applicant_id', 'program_id', 'assigned']], on=['applicant_id', 'program_id'], how='left')
        apps['assigned'] = apps['assigned'].fillna(0)
        apps = apps.sort_values(by=['program_id','score'],ascending=[True,False])
        uc = apps[apps['assigned'] == 1].groupby('program_id').agg(upper_cutoff=('score', 'min'))
        lc = apps[apps['assigned'] == 0].groupby('program_id').agg(lower_cutoff=('score', 'max'))
        vacs = vacs[['program_id']].drop_duplicates()
        vacs = vacs.merge(uc, on='program_id', how='left').merge(lc, on='program_id', how='left')
        vacs['not_filled'] = vacs['upper_cutoff'].isna()
        vacs.fillna(1, inplace=True)
        vacs['iter'] = iterat
    else:
        apps['score'] = apps['priority_profile'] + apps['lottery_number']
        apps = apps.drop(columns=['quota_id'])
        apps = apps.merge(assigned[['applicant_id', 'program_id', 'quota_id']].assign(assigned=1),
                          on=['applicant_id', 'program_id'],how='left')
        apps['assigned'] = apps['assigned'].fillna(0)
        apps = apps.sort_values(by=['program_id', 'quota_id', 'score'], ascending=[True, True, False])
        uc = apps[apps['assigned'] == 1].groupby(['program_id', 'quota_id'])['score'].min().reset_index()
        uc = uc.rename(columns={'score': 'upper_cutoff'})
        lc = apps[apps['assigned'] == 0].groupby(['program_id', 'quota_id'])['score'].max().reset_index()
        lc = lc.rename(columns={'score': 'lower_cutoff'})
        vacs = vacs[['program_id', 'quota_id']].drop_duplicates()
        vacs = vacs.merge(uc, on=['program_id', 'quota_id'], how='left')
        vacs = vacs.merge(lc, on=['program_id', 'quota_id'], how='left')
        vacs['not_filled'] = vacs['upper_cutoff'].isna()
        vacs['upper_cutoff'] = vacs['upper_cutoff'].fillna(1)
        vacs['lower_cutoff'] = vacs['lower_cutoff'].fillna(1)
        vacs = vacs.assign(iter=iterat)[['iter', 'program_id', 'quota_id', 'not_filled', 'lower_cutoff', 'upper_cutoff']]

    cutoffs = pd.concat([cutoffs, vacs], ignore_index=True)
    return cutoffs
