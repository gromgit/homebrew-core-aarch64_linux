class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "https://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/v2.0/frobtads-2.0.tar.bz2"
  sha256 "893bd3fd77dfdc8bfe8a96e8d7bfac693da0e4278871f10fe7faa59cc239a090"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/frobtads"
    sha256 aarch64_linux: "46718e74cb3722e7d6ca57cab177c7e15424be6039bc7f64ffa6c617b7dd7fb7"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match(/FrobTADS #{version}$/, shell_output("#{bin}/frob --version"))
  end
end
