class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/v1.8.0.tar.gz"
  sha256 "11b127b0631ff6db979d7f8c59a6a59cc725e072489abbf676d2557ea6475dab"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/f2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cc3c3e74d55704fbc197c6ed7489a66e2a314242fadf4c6715c7ea5229929dd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd..."
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_predicate testpath/"test1-foo.bar", :exist?
    assert_predicate testpath/"test2-foo.bar", :exist?
    refute_predicate testpath/"test1-foo.foo", :exist?
    refute_predicate testpath/"test2-foo.foo", :exist?
  end
end
