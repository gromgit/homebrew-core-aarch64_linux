class Gotags < Formula
  desc "Tag generator for Go, compatible with ctags"
  homepage "https://github.com/jstemmer/gotags"
  url "https://github.com/jstemmer/gotags/archive/v1.4.1.tar.gz"
  sha256 "2df379527eaa7af568734bc4174febe7752eb5af1b6194da84cd098b7c873343"
  license "MIT"
  head "https://github.com/jstemmer/gotags.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gotags"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a9ba0b62358a33309ac2087691459460f703d5d7149bffb901ed9ffc8d02088f"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"gotags"
    prefix.install_metafiles
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      type Foo struct {
          Bar int
      }
    EOS

    assert_match(/^Bar.*test.go.*$/, shell_output("#{bin}/gotags #{testpath}/test.go"))
  end
end
