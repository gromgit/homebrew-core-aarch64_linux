class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.24.0.tar.gz"
  sha256 "ae794c7b4ffe7cfb6f1edec60556ccda34165b2fea5c23045e332eeebc1077f4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d5e3366c0abdec2bb39979a6603221523703567d18904dea025f7a06284cc60"
    sha256 cellar: :any,                 arm64_big_sur:  "985330913e731e5d8d7c81d64bfb6bf4c78bf9898f57056916c3ba6c5136e9e9"
    sha256 cellar: :any,                 monterey:       "6d834ee1c1972b72674e50ae665ac0f0adf63a63399f106543398d71e4238c4d"
    sha256 cellar: :any,                 big_sur:        "c19a97a0fd2a905f780f7cdd4b775781a40a249b6d35b5fd2d9d2d7b6f8416d2"
    sha256 cellar: :any,                 catalina:       "300b9cfcb0be862cf8e0fc2316082d1d32ab90d772c0873aaa31db720d123d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c87e262e55d031969954d1f4c68333b839888d0be2753e567fde48e78e2b5f91"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end
