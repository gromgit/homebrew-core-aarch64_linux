class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/3d/91/962faecac858237d3d4b194f73ab426bc52878615b11dee7b35ac98b6b19/folderify-2.2.2.tar.gz"
  sha256 "2ce000ffccbb58585213bb477bf25da1f0b9b0a85ed8289baefff5d7041f7043"
  license "MIT"
  # Default branch is "main" not "master"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5648fa8e7a90da4514c5646fcd4cd472cc3874b1b8d1cc9c1b81787fbad71609"
    sha256 cellar: :any_skip_relocation, big_sur:       "dcb3e86eb13c2efb3bf71761ac44d109e5b4becf435318837ee3dc5d897ff86d"
    sha256 cellar: :any_skip_relocation, catalina:      "e481d4b6bca72a9c4962bb69f3805930f332bec45394dff462573ddbc94b4940"
    sha256 cellar: :any_skip_relocation, mojave:        "39560442cbf37b6af98c11bf1f2d9e14a798552db9684381d9381c768dc1d7e5"
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
