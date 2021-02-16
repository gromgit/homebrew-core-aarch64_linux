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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b56e80d1b6eabac87521806039b4cf15c625f35f63d0a8c636a1e82025ca53d"
    sha256 cellar: :any_skip_relocation, big_sur:       "de4134789053813c8779bdbf1f0a4561fc1334c976028ae11f9f2fe1bd77a8d5"
    sha256 cellar: :any_skip_relocation, catalina:      "388a1cdd813fd6be004e6b19caf157e51fd66546353e8d7d5a991dd9479f5647"
    sha256 cellar: :any_skip_relocation, mojave:        "e945cc2979f3f0517ab567db78d311aeb3bfb3df6062916612b583c39df9033d"
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
