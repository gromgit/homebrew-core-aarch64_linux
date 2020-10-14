class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.145.0",
      revision: "ff2495fbd1578347efe00d70d80a05d93976fadb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "431afd44896b1efb38acb1a6b3a4b9d41e850472451ef63294ece5fefd196e21" => :catalina
    sha256 "2a63b85b61e69b848aa1043da487c2f77b1037b8324769bad041c9899573a53e" => :mojave
    sha256 "932bda02b5ab2f84d227487db44b7766c0359d2bbf5b8d8237a7ea9132ffa3b3" => :high_sierra
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
