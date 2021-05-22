class NameThatHash < Formula
  include Language::Python::Virtualenv

  desc "Modern hash identification system"
  homepage "https://nth.skerritt.blog/"
  url "https://files.pythonhosted.org/packages/83/b4/bd1ad28c46023baa8af4a813ee31298c4d3d81937886e900f56af04d634a/name-that-hash-1.9.0.tar.gz"
  sha256 "77f848196b339ec2ae8dc7f2ec1197401eb7cb9605f880c7813b342251e5cf89"
  license "GPL-3.0-or-later"
  head "https://github.com/HashPals/Name-That-Hash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b5b10413c7f0db8048812cf1b96c8db28652ab8817ff5c8b97897adebd550687"
    sha256 cellar: :any_skip_relocation, big_sur:       "d68dd0e5cd302f3e1b9b25f6eb70628c3b659c3c558374cb6f2629656c907237"
    sha256 cellar: :any_skip_relocation, catalina:      "320e2884d56247bd7a3b3465051aa36888758fa19f82359e4f12bd4998cf860c"
    sha256 cellar: :any_skip_relocation, mojave:        "87526b2d414e2eae4cc7f87bd9c3be1e4368a147560df8b55b42456b5e972412"
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1e/cc/ced09195051b5384e9a82d6de7fc1a3917017fe214d30d41a9935cea465d/rich-10.2.2.tar.gz"
    sha256 "17b3f486c38e79cc219d8848974b277ef532a82d12b3ad6eb37bb8c6f22ab5fc"
  end

  def install
    virtualenv_install_with_resources

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-name_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/nth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "MD5, HC: 0 JtR: raw-md5 Summary: Used for Linux Shadow files.\n", output

    system Formula["python@3.9"].opt_bin/"python3", "-c", "from name_that_hash import runner"
  end
end
