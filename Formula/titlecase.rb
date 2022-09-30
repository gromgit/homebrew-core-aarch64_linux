class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.005.tar.gz"
  sha256 "6483798bac1e359be4b3c48b8f710fd35cc4671dfe201322cbb3461a200b4f76"
  license "MIT"
  head "https://github.com/ap/titlecase.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/titlecase"
    sha256 cellar: :any_skip_relocation, x86_64_aarch64_linux: "fb24026539e4fd3db91084f2bf78b21d17e08e0cbd6aaf2acbdccf4cb9079ed6"
  end

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
