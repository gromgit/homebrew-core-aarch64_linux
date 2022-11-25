class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.8.3.tar.gz"
  sha256 "517a43ee6dafd86a85ead1f12b0b4513583463b42e38b64234c6f7435610047b"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91118dde707f7733b5ef0e492b994fd30df8c983a9a83103800ab8329e7c0bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7355f9b10ae5982bead5b86755b4959fe7bba61c83e4f3b52c9fe1beb39256e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e78a0a9fed74982b10ffeca4958f5db4ef6f5f2ceefdb43b40a959972c1b11e3"
    sha256 cellar: :any_skip_relocation, ventura:        "ba2b6cd90e0f77a53b28995368ed90674ad5c0fbe5a8437d1b79640266642b18"
    sha256 cellar: :any_skip_relocation, monterey:       "a6dd1f50d5b16b06971ae3e89aeec4e79df3989ccaab9378828e2dee5ea37035"
    sha256 cellar: :any_skip_relocation, big_sur:        "b27f8fd26eeed106c8ab99c561d912c5671c96408c08cfd11565ab1bbcab639e"
    sha256 cellar: :any_skip_relocation, catalina:       "552e6539d5a89503f7919c019cc1491427f9b3fd633d87351eca7a626d2b6e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1b1a0a755a330617d7344d7fa948d1b70dc372d8a40610f4c72c75a1921f97"
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
