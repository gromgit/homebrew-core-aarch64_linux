class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/4a/ae/77e25559b76ec9e4e5df9f2173b8e008b6199b3049d4fb8d4207bbf68fff/folderify-2.1.1.tar.gz"
  sha256 "4167dcd86878fa0115101959d5437531954a6707dbe207f8cb45425a4547d730"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "67dab09b903e629be04f21a92f1cb7edff692a78d2e5f0a5f404fc0477a659a7" => :big_sur
    sha256 "20944598cedaecd415fad0fa09e336369329be6dc486423c8ed10c9d07f35cbe" => :catalina
    sha256 "b2bce519fa455f363ef24745a6533f032b7abe1ed4f28fb64c718a962c06f150" => :mojave
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
