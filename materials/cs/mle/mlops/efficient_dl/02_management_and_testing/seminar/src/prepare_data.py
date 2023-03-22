from settings import BASE_DIR
from torchvision.datasets import CIFAR10

if __name__ == "__main__":
    train_dataset = CIFAR10(root=BASE_DIR / "CIFAR10" / "train", download=True)
    test_dataset = CIFAR10(root=BASE_DIR / "CIFAR10" / "test", download=True)
