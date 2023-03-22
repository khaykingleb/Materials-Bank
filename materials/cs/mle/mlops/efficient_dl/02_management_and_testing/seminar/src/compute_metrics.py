import json
from argparse import ArgumentParser

import torch
import torchvision.transforms as transforms
import wandb
from hparams import config
from settings import BASE_DIR
from torchvision.datasets import CIFAR10
from torchvision.models import resnet18


def main(args):
    api = wandb.Api()
    run = api.run(f"khaykingleb/effdl_example/{args.run_id}")

    transform = transforms.Compose(
        [
            transforms.ToTensor(),
            transforms.Normalize((0.4914, 0.4822, 0.4465), (0.247, 0.243, 0.261)),
        ]
    )

    test_dataset = CIFAR10(
        root=BASE_DIR / "CIFAR10" / "test",
        train=False,
        transform=transform,
        download=False,
    )

    test_loader = torch.utils.data.DataLoader(dataset=test_dataset, batch_size=config["batch_size"])

    device = torch.device("cuda")

    model = resnet18(pretrained=False, num_classes=10)
    model.load_state_dict(torch.load("model.pt"))
    model.to(device)

    correct = 0.0

    for test_images, test_labels in test_loader:
        test_images = test_images.to(device)
        test_labels = test_labels.to(device)

        with torch.inference_mode():
            outputs = model(test_images)
            preds = torch.argmax(outputs, 1)
            correct += (preds == test_labels).sum()

    accuracy = correct / len(test_dataset)

    run.summary["accuracy"] = accuracy
    run.summary.update()

    with open("final_metrics.json", "w+") as f:
        json.dump({"accuracy": accuracy.item()}, f)
        print("\n", file=f)


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--run-id", type=str, required=True)
    args = parser.parse_args()
    main(args)
