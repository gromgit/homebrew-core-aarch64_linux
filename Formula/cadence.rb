class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.25.0.tar.gz"
  sha256 "21166a0edd516b7f8c223388a6e1639f054af8318c3e87b133bc8c6bb8d239fd"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cadence"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1c1f9ee7ae81b008572c14d3ca9db13145911021dcebe9631cdbe9fdd991ee88"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
