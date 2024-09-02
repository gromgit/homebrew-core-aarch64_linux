class Chgems < Formula
  desc "Chroot for Ruby gems"
  homepage "https://github.com/postmodern/chgems#readme"
  url "https://github.com/postmodern/chgems/archive/v0.3.2.tar.gz"
  sha256 "515d1bfebb5d5183a41a502884e329fd4c8ddccb14ba8a6548a1f8912013f3dd"
  license "MIT"
  head "https://github.com/postmodern/chgems.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/chgems"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "132c84a07d7758f44343b574509ee62afff25a92c8ed28f78bf1a6e6bc001408"
  end

  deprecate! date: "2021-12-09", because: :repo_archived

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chgems . gem env")
    assert_match "rubygems.org", output
  end
end
