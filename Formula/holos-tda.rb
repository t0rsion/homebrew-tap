class HolosTda < Formula
  desc "Vietoris-Rips persistence and checked degree-Rips modules"
  homepage "https://github.com/t0rsion/holos"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "fc42e5dfc505ad0dbb0afe08dff83da606f895db0eca884adae78af1adfa4076"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "3becb9c384a61e754a34761bd82842ab32c50eed741349f0021ff59cec8d9804"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e535f8dcccdc53668ad261ef0597d0d3703d2d84f9e8a66d7cff6d98e1a54415"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.9.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4dcc78cebe3449089639cefe6ea3b339526316cf27daf1ceefa60cae78991e1f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
