class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/9e/30/e5779f9dbe1a470ee72d34843c7414bcbc3e025db50d50f3e7d50232704d/pipgrip-0.6.12.tar.gz"
  sha256 "b29e48dd8a9a6e6be2b1f0c3bf1aafb2bd16d609169f43ef254b7503b70daaaa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce3dd5b1c1ab09096abf41da8232aaf1816567e12f6cd3e4b89656286358ceb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc692e49f66513bb51a34430923aa3d1118a7f75b9152b46fdf2cd5cb7b95839"
    sha256 cellar: :any_skip_relocation, monterey:       "9d937406051aafc1e3db327b616f3ef21780397b7521eef970626102dcc92d5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a67a2c90e5074e757d5698572e5b9ab3ced8646fa404fbe593463099f5ff2eb"
    sha256 cellar: :any_skip_relocation, catalina:       "e6c178b93ee57c1666364b397d4779804df9932f7dc6132e76a3211955fc16a9"
    sha256 cellar: :any_skip_relocation, mojave:         "019e6176aa868cf0239c7453327efe451bc017c83f6a9a71bc1dccb080890556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5e852cc19aae300f9cd978d5b88b69ead11455780935b41b6a8e17103a1f7b"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
