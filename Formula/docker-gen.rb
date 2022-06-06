class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.0.tar.gz"
  sha256 "9f270363d872e4d302b67b3baa3baec4d1c7b892814fd6a50e5953a2b90d745e"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/docker-gen"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "92a98b1ba2fbc7cb211a241e237ee4e655c64e3d88675ac428c7d71d0a5d1424"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
