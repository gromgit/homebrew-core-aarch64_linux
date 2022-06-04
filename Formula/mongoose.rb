class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.6.tar.gz"
  sha256 "1ef09d971b6de1a6317c109980d6fb5a9c19b39efef2506d6b76869644b3dafa"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f126fdd9f6594e57279610b75ff8851a8ab6203218170fdea68864b93daa658"
    sha256 cellar: :any,                 arm64_big_sur:  "874f0ab8d21ff9e57bc02070cff37d1ad8ae42d1aeaedad5fe5107704cbf7ece"
    sha256 cellar: :any,                 monterey:       "282c1fdd01b11ae3989e8dc9c0e54f55ce56b267b041635eb5d10f280e5c16d8"
    sha256 cellar: :any,                 big_sur:        "924e80fd8b69d95f3e771e453f5a3b290ea68670c3e0cf83cb1fc2e24b2e8ce6"
    sha256 cellar: :any,                 catalina:       "4bcddf3f3550af73ea676900fba6f89d56a59a69fe1bc96a929cbd9f3e553ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652ef3c9d9e7d2ee5daeb689ca5a9fd86e290918d6d7363bfc0d25284d33b837"
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/http-server" do
      system "make", "mongoose_mac", "PROG=mongoose_mac"
      bin.install "mongoose_mac" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib" if OS.mac?
    if OS.linux?
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
    end
    lib.install shared_library("libmongoose")
    include.install "mongoose.h"
    pkgshare.install "examples"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
