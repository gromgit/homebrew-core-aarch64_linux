class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.0.0.tar.gz"
  sha256 "c4f5629c9fca7ede7664063a318021f58c7909cbff822dad8dca88da7d9043c2"
  license "ISC"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "aa62a711583a594d57933cbd958b0d4485b5ca4f971804e53e468c8ec09e5109" => :catalina
    sha256 "ee74e5ce481203e66ba7f9227b3f59a2f7bf33814a80d584e9213175e753240b" => :mojave
    sha256 "2e9bd366c8be331cf17b1819abc697d7f1fd8b88ec17bf80ad07d5999313b545" => :high_sierra
  end

  depends_on macos: :sierra # needs clock_gettime

  depends_on "openssl@1.1"

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl@1.1"].opt_include

    system "make", "PREFIX=#{prefix}", "TASKS=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
