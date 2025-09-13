import time
import os

START_TIME = time.time()
READINESS_DELAY = int(os.getenv("READINESS_DELAY", "0"))

def is_alive() -> bool:
    # Simple always-true check; extend as needed.
    return True

def is_ready() -> bool:
    # Ready after READINESS_DELAY seconds have elapsed since process start.
    return (time.time() - START_TIME) >= READINESS_DELAY

def startup_ok() -> bool:
    # App has started (imported and Django loaded).
    return True
