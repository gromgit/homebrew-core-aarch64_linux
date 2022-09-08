class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.6.5.tar.gz"
  sha256 "c98d2410d373325aabf3e8140cd4a16cf72bade4029cb921eef7807cc04a78f9"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ed32b280761256f1c7a6b475c95aa2cdde0ee6a3bb0869277b700d3f7be30c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c273b6abcd1196ba07d90d0edfa3e1a259e501b94b1c4b26f6591fdd248b73e"
    sha256 cellar: :any_skip_relocation, monterey:       "7b4b3279f3d59e79e4c4af9fe94bfe70d7962f8713edc868f58e1263f2078454"
    sha256 cellar: :any_skip_relocation, big_sur:        "5915081141a6dcfd4ab76d74ef191eed257b022a8458a3975a272f9f00a3e941"
    sha256 cellar: :any_skip_relocation, catalina:       "6644ba2e6a5639296afab989af3c744af3e51174d2adaf599f19948442ee594e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e539ba23eef1dd024ccc4498cb13998b2bf0c858ef2b7e69219ecd29ffd91be"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
