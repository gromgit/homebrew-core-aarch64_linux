class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/f1/ed/59cf4c42e58e768acc46ed08e71cd7402c6aee7f127e1dd5cb8e9ebd9b2f/folderify-2.2.0.tar.gz"
  sha256 "e9b8c30bf60e53f56864fd818ea4bf5928a2acc183db415aa16ae24545a423af"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8fc2403cf530317e6c9eeab8a007fe065b57e67503b4ba0122244ee53ef95dc1"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbe1b559eeb625d2b0891755e38604b7555443ef8141c1ee561d45c3ba8f8f78"
    sha256 cellar: :any_skip_relocation, catalina:      "ccef2136e9afb9ec00cf44ecae6d9e5754ba131107a48a386200648989e9bc6b"
    sha256 cellar: :any_skip_relocation, mojave:        "9c800829697717e4d52fe26101dd8b9313f5ee1587aa92adee3b645cc367b0c8"
  end

  depends_on "imagemagick"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # Copies an example icon
    cp("#{libexec}/lib/python3.9/site-packages/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
    "icon.png")
    # folderify applies the test icon to a folder
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
