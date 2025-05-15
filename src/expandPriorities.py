import pandas as pd

def expandPriorities(prg_id=None, quo=None, prio_id=None):
    if prg_id is None:
        prg_id = []
    if quo is None:
        quo = []
    if prio_id is None:
        prio_id = []

    # Fix: check if input arrays are empty
    if len(prg_id) == 0 or len(quo) == 0 or len(prio_id) == 0:
        return pd.DataFrame(columns=["program_id", "quota_id", "priority_profile"])

    # Cartesian product
    index = pd.MultiIndex.from_product(
        [prg_id, quo, prio_id],
        names=["program_id", "quota_id", "priority_profile"]
    )
    grid = index.to_frame(index=False)

    # Coerce priority_profile to numeric (if needed)
    grid["priority_profile"] = pd.to_numeric(grid["priority_profile"], errors="coerce")

    # Sort
    grid.sort_values(
        by=["program_id", "quota_id", "priority_profile"],
        ascending=[True, True, False],
        inplace=True
    )

    return grid
