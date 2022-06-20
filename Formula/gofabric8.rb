class Gofabric8 < Formula
  desc "CLI for fabric8 running on Kubernetes or OpenShift"
  homepage "https://github.com/fabric8io/gofabric8/"
  url "https://github.com/fabric8io/gofabric8/archive/v0.4.176.tar.gz"
  sha256 "78e44fdfd69605f50ab1f5539f2d282ce786b28b88c49d0f9671936c9e37355a"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gofabric8"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4200cea27831ea7c68a7cc20456f72cb627021bd9bb50d24d945d7f6f17f19ff"
  end

  deprecate! date: "2020-11-27", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/fabric8io/gofabric8"
    dir.install buildpath.children

    cd dir do
      system "make", "install", "REV=homebrew"
      prefix.install_metafiles
    end

    bin.install "bin/gofabric8"
  end

  test do
    Open3.popen3("#{bin}/gofabric8", "version") do |stdin, stdout, _|
      stdin.puts "N" # Reject any auto-update prompts
      stdin.close
      assert_match "gofabric8, version #{version} (branch: 'unknown', revision: 'homebrew')", stdout.read
    end
  end
end
