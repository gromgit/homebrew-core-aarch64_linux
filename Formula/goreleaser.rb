class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.152.0",
      revision: "f87e1caf26563fc7eb2023a58ff6886cae3b2ab5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "70f92a0903bda1336b70b4023b4e8fba23943a80ea6b3d845b5477a836acbcfd" => :big_sur
    sha256 "36fb012d683b97af2e4b5aedba72d28f43a8f5a4d5fc441f5f9a2d13d552fef4" => :arm64_big_sur
    sha256 "c0c85cd214c71b8f32e6d9d34193d484c4fff8c4ac29ded2e4f5ca82f4ff23ff" => :catalina
    sha256 "4c8c6bfc9abe58e46f70cbaaa90c30a3605d3addad5a51687a49ab0416eaa3d1" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
