class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/ad/fe/4989e174549aef5d0d320b18a29727f55a0fa87985e1d9ec61466a7fbd66/awsume-4.5.1.tar.gz"
  sha256 "88f2a085bcb99178d0df36ebaec22412068bb89d63a2c36e9ada1e8d64ebce03"
  license "MIT"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0060e3d76e2fabfdd8a037ff258d95c4df87cc297c180c45fe724fda1a470f5b"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa6d4309582c604ce00ba83e7e6b2f15d8dc91b280bc85ee235d7912e62b50fa"
    sha256 cellar: :any_skip_relocation, catalina:      "d40f48b8b4c7f3ed85cb5ce655946e3e8968ad785dccba47ba60e35745fc9a57"
    sha256 cellar: :any_skip_relocation, mojave:        "c9c8f5a9a027e89eb52ca3c081a5f7afb86e464946f9a1f8c289cc054f9d60e8"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.9"
  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/07/8f/26740695fa4e6fa47a6a3794f375a7d8be1626858ef6f541b9465029dee1/boto3-1.17.71.tar.gz"
    sha256 "edf9b3b36e08cd575a9458bf59871852335aceb5db2d07bfc8530bae3a97d045"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/36/10/0aad4fae034a4b395ab67cb6943b57224c70bccebe046cb17cb9bbf94b44/botocore-1.20.71.tar.gz"
    sha256 "b7afebca1fd6ca1f8af79f377a445d474e3bd2cf88e704169d6713a6362a304f"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output(". #{bin}/awsume -v 2>&1")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT", shell_output(". #{bin}/awsume --list-profiles 2>&1")
  end
end
