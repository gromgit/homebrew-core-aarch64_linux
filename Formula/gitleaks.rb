class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.12.0.tar.gz"
  sha256 "8e4df138f39951b0de70fe062d6f7c58232b692b52893a40da388a39cd77eaa0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19018d38052fcd358e7b3a6adf687d376652a2334dbbe2653fe56af7418df2f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20c2e0048fa0c6b5528874bbbfac1100336dbaa29530f681d2701cba826de3c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f88b5cf7092417b2fe01cdb648f382b79d154c6c3f7496738d720fa69ac366ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "e072c80cd89de2cb73a6ed8794ce0502f00b15da7ce43c61717a4e0bab4f4561"
    sha256 cellar: :any_skip_relocation, catalina:       "e3889469e2a52f42aab2922818dc4c763cdd8099bff4ac8381ff4dcae61eb3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708e7a8cdcd889307d7e998a3fdbc085af52e08586ea999f0cbcc3c392276286"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
