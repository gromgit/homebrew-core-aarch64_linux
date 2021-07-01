class Evernote2md < Formula
  desc "Convert Evernote .enex file to Markdown"
  homepage "https://github.com/wormi4ok/evernote2md"
  url "https://github.com/wormi4ok/evernote2md/archive/v0.17.0.tar.gz"
  sha256 "cd9a4568dbf9f4d016533dee8d0b6af1ffe5d365e5f38376ce054260a772582a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "001e043a17000dca3ad622086ea915f3abf6a115ba0f9723c6b69c29cdca60d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d60a426d064e608098eff7554ac8a7c6d44d5a609ec10ced771ff6e8af6f6b14"
    sha256 cellar: :any_skip_relocation, catalina:      "9b8e540ddd705699e012b36bfb57c414c0e62c225fedda2aaab82660ae63f748"
    sha256 cellar: :any_skip_relocation, mojave:        "11786e10cba4330853de4222b306513f080b7013eaf324fc5b5ab108f3937951"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"export.enex").write <<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export3.dtd">
      <en-export>
        <note>
          <title>Test</title>
          <content>
            <![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><div><br /></div></en-note>]]>
          </content>
        </note>
      </en-export>
    EOF
    system bin/"evernote2md", "export.enex"
    assert_predicate testpath/"notes/Test.md", :exist?
  end
end
