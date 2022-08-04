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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b021f2ae8630c9aca1a59e0b2bb8bfa20ec9080d98bb29603f54d7974788ae26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "227ebaee619e9442604df1c29c58d04e4a97e0006dc7bfb27136d95df0f03058"
    sha256 cellar: :any_skip_relocation, monterey:       "8385f0a0494d3add6cdd5b7dafa32a0713c0deafcfc01e6c1e15eb8d6e1e11f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbb4ee96e440dd83ff5535ecdf58747559ab8e2550d5a8918a8450626fe2385d"
    sha256 cellar: :any_skip_relocation, catalina:       "d6bb2116067b03dc49c9d23ad294e67735949a59043cbace0f957d206ce51d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85c5895a91aa0c858b3d3e7845961aab45a6da4c5517824b93b90e02afc5b490"
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
