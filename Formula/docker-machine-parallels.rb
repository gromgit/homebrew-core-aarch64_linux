class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.2.0.tar.gz"
  sha256 "bac8e194adb06f1ad07fa2f00573b4293eba47943de97210b73f3f70dc0aef5d"

  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39062149f2d3130ee6d9a6d61d3b887086c98b38dc9561d819135c828605a8ba" => :el_capitan
    sha256 "8ad00f44d3b7a1ef6c32fe0caa57fe7424df3739e5284ab580fc90e5ebd7849b" => :yosemite
    sha256 "bd8fa78ac56fdefe542378f18cfce9e44b73cfb00f751d27ca6c22debe4a42cb" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/Parallels/docker-machine-parallels"
    path.install Dir["*"]

    cd path do
      system "make", "build"
      bin.install "bin/docker-machine-driver-parallels"
    end

    prefix.install_metafiles path
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
