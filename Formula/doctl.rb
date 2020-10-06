class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.48.0.tar.gz"
  sha256 "43f4be1a5316688579c3df1846dc7088478dc5ddc3e4fa1176a953609123f046"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c42d05130e0ce318ca724659e6df2b68eb9936b67efaea381551f147fd5ca010" => :catalina
    sha256 "049976e7b0ef332afa67be7c815c7bcf43432633c9016dd361e0b9f4d63cccb4" => :mojave
    sha256 "b5a61c048bc5f617f2d3841b56b51e9f8b7c49acc2de940bfb782a188afabc5c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, *std_go_args, "github.com/digitalocean/doctl/cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
