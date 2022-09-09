class Echidna < Formula
  desc "Ethereum smart contract fuzzer"
  homepage "https://github.com/crytic/echidna"
  url "https://github.com/crytic/echidna/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "117808e1d9b3bdd7c3400c5849b5e5a5461b4ad8035ca9a899b0713e7a5ea40c"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/echidna.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f824fb087daa0510609545dcd039b64b45632a5d33ad40877f86ee4eeb5d0223"
    sha256 cellar: :any,                 arm64_big_sur:  "b1253ae03416bb1d0d54a083c98fff0e68eee584df18a4ba4cf563af0dfeb3ed"
    sha256 cellar: :any,                 monterey:       "988aed91e01be93981b6af2178e57cbd99fa73bd415aa801cb5ed8081e93521d"
    sha256 cellar: :any,                 big_sur:        "bd56181a5ab3aa08e3873cb33f3594b02101283d0fc2b21d4cb0ad6b79b023cf"
    sha256 cellar: :any,                 catalina:       "485ae8b9dcc8270e01a116ed903e0c26ebbd20506726c6b1a80adf2a73089d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4acf4152b058040edff48a064be7357c534e937265a25b43eed303c779e4e139"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "libtool" => :build

  depends_on "crytic-compile"
  depends_on "libff"
  depends_on "slither-analyzer"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "secp256k1" do
    # this is the revision used to build upstream, see echidna/.github/scripts/install-libsecp256k1.sh
    url "https://github.com/bitcoin-core/secp256k1/archive/1086fda4c1975d0cad8d3cad96794a64ec12dca4.tar.gz"
    sha256 "ce97b9ff2c7add56ce9d165f05d24517faf73d17bd68a12459a32f84310af04f"
  end

  def install
    ENV.cxx11

    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", *std_configure_args,
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--libdir=#{libexec}/lib",
                            "--enable-module-recovery",
                            "--with-bignum=no",
                            "--with-pic"
      system "make", "install"
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    ghc_args = [
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--extra-include-dirs=#{Formula["libff"].include}",
      "--extra-lib-dirs=#{Formula["libff"].lib}",
      "--extra-include-dirs=#{libexec}/include",
      "--extra-lib-dirs=#{libexec}/lib",
      "--ghc-options=-optl-Wl,-rpath,#{libexec}/lib",
      "--flag=echidna:-static",
    ]

    system "stack", "-j#{jobs}", "build", *ghc_args
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install", *ghc_args
  end

  test do
    system "solc-select", "install", "0.7.0"

    (testpath/"test.sol").write <<~EOS
      contract True {
        function f() public returns (bool) {
          return(false);
        }
        function echidna_true() public returns (bool) {
          return(true);
        }
      }
    EOS

    with_env(SOLC_VERSION: "0.7.0") do
      assert_match(/echidna_true:(\s+)passed!/,
                   shell_output("#{bin}/echidna-test --format text #{testpath}/test.sol"))
    end
  end
end
