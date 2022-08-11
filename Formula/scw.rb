class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.5.6.tar.gz"
  sha256 "f2b52527e51087f29e67b76282df425ce383083fff6bfb48b531dc22fa259fc3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5379455278e1187dff426d59710c806bc7c4e02c25f5e8df9d8dde8d33d74aa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "242ad9065cca25a56b81617994d7856fcde762af864c8513da459540064b09d2"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6774231a3bc31b01682e73e74b3387b58ac8164c2ba0ca965f1eb42f37e422"
    sha256 cellar: :any_skip_relocation, big_sur:        "06fa07e30ef0c7a8ed6a285dd4328cec085401d100cb5b71d92cfeb4f77444f5"
    sha256 cellar: :any_skip_relocation, catalina:       "36b0e506d03f5ed38883f059f167cdafa4436938cddff86c07e81c50e6aa16a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47cef9786d2ab1b7d051ca1789840cbd9838d5ab6f01ff3b98f205ed25b138c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
