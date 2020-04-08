class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.40.0.tar.gz"
  sha256 "2a1877097183b9a47bad7a0942174b4a98ad6182db29d7d76720ee709fcf4c02"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d2e9299897198232be035d7f9e44548f1f30a4fd6017a985171f62ca8726432" => :catalina
    sha256 "1447c8b1ccf051028d66a0f2f40a5a741120a1a179daea3af2c71cf6aeb935e1" => :mojave
    sha256 "5f16e005f514d492247a90d4eec34af46485d6ae4012e48324476967656cc97b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
