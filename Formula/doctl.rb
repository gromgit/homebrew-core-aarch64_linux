class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.82.0.tar.gz"
  sha256 "d555d5fe417fce0850cff7fdbb87259f8a14dc7fb2ff56746bef8fcdd746d949"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38088ed4c9fe7097896ae7679baa34575a82760d906150611a8fe79f48cc33f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "607c814f120df71cf10b87d1785929c945ba6e532819af8fc575c00257ed2e60"
    sha256 cellar: :any_skip_relocation, monterey:       "7549ab972c618c6ddf4e08282f5b6739157adfc0c4be32932872020a4028e6a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5742089b279f336072f3cda2c01eab99eecad4e92b4c8c72361f56ab3be4bf30"
    sha256 cellar: :any_skip_relocation, catalina:       "33f322408d1534efb3d3e66ca35b3997f6214af0a62b24a331b062c9890d04df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2facdadbad3dd29bb8f4f572050928aedc5f00818cf99d5fca4f980d93ccdd59"
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
