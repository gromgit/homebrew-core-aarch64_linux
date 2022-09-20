class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/c2/c0/c0eff47622486753163a482abe9b96f83e613b49913e62a54f371db9b1aa/detect_secrets-1.3.0.tar.gz"
  sha256 "a93ef7d141f48a3a6531bc6d4ccf6d022d23bc10afd1e100a91ca9d2c25abb90"
  license "Apache-2.0"
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34b52b38cea619e3217d114d1f42c024736717e8fd0de7e1bb736dac1cc3b1f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad9fcd1e24721635cf482c47f365a5eb1052da4efc2100271c7cf8f4fdbfb44"
    sha256 cellar: :any_skip_relocation, monterey:       "326f0c16b88ebb1bfa16141c8bdb276ac7b39a2ba9c1e4f50731621d51604666"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e865348fc06766d25cd35e8ba395d93e06a3060edd6d7f5cb76e0a7c27ac82"
    sha256 cellar: :any_skip_relocation, catalina:       "48baee45d75e9381fcf844aba9998c021c41b044b29724c9e82149e38cafa16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "357460349ab238c4e5df75de6959db3eea7cfdc968764b4172afa94de5f41923"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
