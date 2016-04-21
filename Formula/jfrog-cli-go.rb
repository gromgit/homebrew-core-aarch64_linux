require "language/go"

class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.1.0.tar.gz"
  sha256 "62550b0f544cc0e814b1c9b1bf96999152fd79f1fe981f755a2ec71f4acae4ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "15bd2a61a6398560fb8cdaa83725e1a788626471d87b9b3cdd9493bf5b137aec" => :el_capitan
    sha256 "1ea8d236dae9ed674b407d7514d79b29228d9837484785cf4c11e9f373e5a7c4" => :yosemite
    sha256 "6ec5e9a6e513b5ee761d10d6096039167d8e405fe7097535e1c0f4517eed2f4d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JFrogDev/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/JFrogDev/jfrog-cli-go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/jfrog", "github.com/jfrogdev/jfrog-cli-go/jfrog"
  end

  test do
    assert_equal "jfrog version 1.1.0", shell_output("#{bin}/jfrog -v").chomp
  end
end
