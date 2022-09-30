class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.82.1.tar.gz"
  sha256 "c104a6ad5efef3a7b71f2e539d0a9ab6a59f607669e520ba48b2afe8f077d12a"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74c02982b089c4aed2164bafc84b258076905f98bc3171ce4897d28723a52667"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2300d582968285b957f61227db457c7239cf0eb13bc2c19bda913f93acfc74c5"
    sha256 cellar: :any_skip_relocation, monterey:       "28ec47c3e6e621e326e58e2a264777b96e4b800a81af62dc2cc2bfb64d32be17"
    sha256 cellar: :any_skip_relocation, big_sur:        "a872dabe312c01ddb654d40cbf9fd5bab0c509ad091c29d04159c5384d39dffc"
    sha256 cellar: :any_skip_relocation, catalina:       "b5f5d818476be0a44b2584e22c169e81df545a79edb388448d1a9a687a4d7a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f9bd24341aeb6b4a2fbe2f920ff9c1d7a1314fcd40dd544c04424fc6ddac0a"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
