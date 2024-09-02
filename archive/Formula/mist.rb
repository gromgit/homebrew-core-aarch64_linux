class Mist < Formula
  desc "Mac command-line tool that automatically downloads macOS Installers / Firmwares"
  homepage "https://github.com/ninxsoft/Mist"
  url "https://github.com/ninxsoft/Mist/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "49a362396014460847b7b04c2f6347c10da73e2d0348543ac26d78ac30cd9f6e"
  license "MIT"
  head "https://github.com/ninxsoft/Mist.git", branch: "main"

  # Mist requires Swift 5.5
  depends_on xcode: ["13.1", :build]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/mist"
  end

  test do
    # basic usage output
    assert_match "-h, --help", shell_output("#{bin}/mist").strip

    # check we can export the output list
    out = testpath/"out.json"
    shell_output("#{bin}/mist list --quiet --export #{out} --output-type json").strip
    assert_predicate out, :exist?

    # check that it's parseable JSON in the format we expect
    parsed = JSON.parse(File.read(out))
    assert_kind_of Array, parsed
  end
end
