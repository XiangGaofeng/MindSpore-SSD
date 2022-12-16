"""hub config."""
from src.ssd import SSD300, ssd_mobilenet_v2
from src.config import config

def create_network(name, *args, **kwargs):
    if name == "ssd300":
        backbone = ssd_mobilenet_v2()
        ssd = SSD300(backbone=backbone, config=config, *args, **kwargs)
        return ssd
    raise NotImplementedError(f"{name} is not implemented in the repo")
