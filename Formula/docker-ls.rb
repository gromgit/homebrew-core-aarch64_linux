class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      tag:      "v0.5.0",
      revision: "0eb4c9ab7f04f48dadd9e32aecace4a7da2270e5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ca16daa59b3fcb5cf7196492d8307b1f40fa92932f9573d9568c9acd3806e20" => :big_sur
    sha256 "8e08cc258716c42f48d8000423772dfb00903b85b18e3633c53dad99697b4210" => :catalina
    sha256 "5994442415bfbcc775069311428b7f3b810e5ca09ff7af25f2c3a322d8105786" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/mayflower/docker-ls").install buildpath.children

    system "go", "generate", "github.com/mayflower/docker-ls/lib"

    cd "src/github.com/mayflower/docker-ls" do
      system "go", "build", "-o", bin/"docker-ls", "./cli/docker-ls"
      system "go", "build", "-o", bin/"docker-rm", "./cli/docker-rm"
      prefix.install_metafiles
    end
  end

  test do
    assert_match /\Wlatest\W/m, pipe_output("#{bin}/docker-ls tags \
      -r https://index.docker.io -u '' -p '' \
      --progress-indicator=false library/busybox \
    ")

    assert_match /401/, pipe_output("#{bin}/docker-rm  \
      -r https://index.docker.io -u foo -p bar library/busybox:latest 2<&1 \
    ")
  end
end
