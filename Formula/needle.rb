class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  # TODO: Check if a GitHub tarball is sufficient here.
  url "https://github.com/uber/needle.git",
      tag:      "v0.19.0",
      revision: "9d15211866bd307c7bfef789fe77ce1e97aeb978"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1929735212f6d3ee84ac3019cd82d4b76e352f780e68f22e381a44e687ae59a0"
    sha256 cellar: :any, big_sur:       "efd84a4bd0890a28c3b9e7d2d9ac9b84a8f4d6bb6a0586380f4d653a6092e52a"
    sha256 cellar: :any, catalina:      "f45fa77b9e00be408206fc2cf945f41ca3f4661bbb06c8d2aadd015f4d75dfdd"
  end

  depends_on xcode: ["13.0", :build] # Swift 5.5+
  depends_on :macos

  def install
    # Avoid building a universal binary.
    swift_build_flags = (buildpath/"Makefile").read[/^SWIFT_BUILD_FLAGS=(.*)$/, 1].split
    %w[--arch arm64 x86_64].each do |flag|
      swift_build_flags.delete(flag)
    end

    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}", "SWIFT_BUILD_FLAGS=#{swift_build_flags.join(" ")}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(libexec/"lib_InternalSwiftSyntaxParser.dylib")
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      protocol ChildDependency: Dependency {}
      class Child: Component<ChildDependency> {}

      let child = Child(parent: self)
    EOS

    assert_match "Root\n", shell_output("#{bin}/needle print-dependency-tree #{testpath}/Test.swift")
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
