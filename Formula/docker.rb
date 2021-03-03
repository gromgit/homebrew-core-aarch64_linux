class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.5",
      revision: "55c4c88966a912ddb365e2d73a4969e700fc458f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c6caf22198400823aa6cd3b8f445e9db040cfeb9972777f6f098c13d64b360f"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6f617417365aa73f3f47714e0ae97e2ac3f095c9aa72eda7cc48d7c63d1be5e"
    sha256 cellar: :any_skip_relocation, catalina:      "8800f8263992fa688c7e781234d06e6fb3c5609ca34a73a3ca8319411a58f565"
    sha256 cellar: :any_skip_relocation, mojave:        "60d84c48b535e3cef613b2f81b2e0ef4e892de962217cd88b5d75bd315b2c73c"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/docker/cli"
    dir.install (buildpath/"").children
    cd dir do
      commit = Utils.git_short_head
      build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{build_time}\"",
                 "-X github.com/docker/cli/cli/version.GitCommit=#{commit}",
                 "-X github.com/docker/cli/cli/version.Version=#{version}",
                 "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]
      system "go", "build", "-o", bin/"docker", "-ldflags", ldflags.join(" "),
             "github.com/docker/cli/cmd/docker"

      Pathname.glob("man/*.[1-8].md") do |md|
        section = md.to_s[/\.(\d+)\.md\Z/, 1]
        (man/"man#{section}").mkpath
        system "go-md2man", "-in=#{md}", "-out=#{man/"man#{section}"/md.stem}"
      end

      bash_completion.install "contrib/completion/bash/docker"
      fish_completion.install "contrib/completion/fish/docker.fish"
      zsh_completion.install "contrib/completion/zsh/_docker"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")
    assert_match "ERROR: Cannot connect to the Docker daemon", shell_output("#{bin}/docker info", 1)
  end
end
