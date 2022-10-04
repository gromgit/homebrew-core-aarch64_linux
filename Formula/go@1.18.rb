class GoAT118 < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://go.dev/"
  url "https://go.dev/dl/go1.18.7.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.18.7.src.tar.gz"
  sha256 "9467e33b819f71bebb21fb0ee1dd6794fd2244ae94907a984286712f9839a944"
  license "BSD-3-Clause"

  livecheck do
    url "https://go.dev/dl/"
    regex(/href=.*?go[._-]?v?(1\.18(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b1a03891b767759e4ddb7ca7a4ccc374d52823dc49b7b16ae0e33ae22f499f9b"
    sha256 arm64_big_sur:  "191203597646177ce179318499eceb7bc5ca0046d63a5865ae80837ed1704556"
    sha256 monterey:       "2d1b3c2012bdbdef51feb1e1002e681c49637e5b4675f22f59c3b412b9ec091d"
    sha256 big_sur:        "2b1afdf7a53e1006f24e4a8f7d87f19f2624be879dfe4fe7876b7e824f122c92"
    sha256 catalina:       "7c6df0f28dbd368cd02a6addf0994f9b8ebc1c00b1ccf9492f76e1e40b6e1dd0"
    sha256 x86_64_linux:   "89725ef8cfee0c7a63c615a5987dffd273c6e3ae30e15494151f2d804cb5861e"
  end

  keg_only :versioned_formula

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    checksums = {
      "darwin-arm64" => "4dac57c00168d30bbd02d95131d5de9ca88e04f2c5a29a404576f30ae9b54810",
      "darwin-amd64" => "6000a9522975d116bf76044967d7e69e04e982e9625330d9a539a8b45395f9a8",
      "linux-arm64"  => "3770f7eb22d05e25fbee8fb53c2a4e897da043eb83c69b9a14f8d98562cd8098",
      "linux-amd64"  => "013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2",
    }

    arch = "arm64"
    platform = "darwin"

    on_intel do
      arch = "amd64"
    end

    on_linux do
      platform = "linux"
    end

    boot_version = "1.16"

    url "https://storage.googleapis.com/golang/go#{boot_version}.#{platform}-#{arch}.tar.gz"
    version boot_version
    sha256 checksums["#{platform}-#{arch}"]
  end

  def install
    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end
